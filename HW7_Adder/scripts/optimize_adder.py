"""
LLM-Yosys optimization loop template.
Fill OPENAI_API_KEY and run from scripts/ after installing yosys and openai:
  export OPENAI_API_KEY=...
  python optimize_adder.py --baseline ../golden/RCA8.v --top adder8 --mode balanced
"""
import argparse, json, os, subprocess, re
from pathlib import Path
from openai import OpenAI

SYSTEM_PROMPT = """You are an expert digital circuit designer. Generate synthesizable Verilog for an 8-bit combinational adder named adder8 with ports output [7:0] sum, output cout, input [7:0] a, b. Return only valid Verilog code, no markdown."""

def synthesize(verilog_file, top_module):
    env = os.environ.copy(); env['ADDER_FILE']=str(verilog_file); env['TOP_MODULE']=top_module
    p = subprocess.run(['yosys','-s','synth_adder.ys'], capture_output=True, text=True, env=env)
    log = p.stdout + p.stderr
    if p.returncode != 0: raise RuntimeError(log)
    m = re.search(r'Number of cells:\s+(\d+)', log); cells = int(m.group(1)) if m else None
    m = re.search(r'Longest topological path.*?\((\d+) levels?\)', log, re.S); levels = int(m.group(1)) if m else None
    return {'cell_count': cells, 'logic_levels': levels, 'area_um2': None}

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--baseline', default='../golden/RCA8.v')
    ap.add_argument('--top', default='adder8')
    ap.add_argument('--mode', choices=['area','delay','balanced'], default='balanced')
    ap.add_argument('--max_iter', type=int, default=10)
    args = ap.parse_args()
    target = {'area':14, 'delay':6, 'balanced':10}[args.mode]
    client = OpenAI(api_key=os.environ['OPENAI_API_KEY'])
    baseline = Path(args.baseline).read_text()
    history = [{'role':'user','content':f'Start from this baseline, but output module name adder8. Delay target <= {target} logic levels.\n{baseline}'}]
    best = {'cell_count': 10**9, 'logic_levels': 10**9}; results=[]; best_code=''
    for i in range(1,args.max_iter+1):
        r = client.chat.completions.create(model='gpt-4o', messages=[{'role':'system','content':SYSTEM_PROMPT}]+history)
        code = r.choices[0].message.content.strip().replace('```verilog','').replace('```','')
        fname = Path(f'candidate_{args.mode}_{i}.v'); fname.write_text(code)
        try:
            ppa = synthesize(fname, args.top)
            results.append({'iteration':i,'file':str(fname),'ppa':ppa})
            if ppa['logic_levels'] is not None and ppa['logic_levels'] <= target and ppa['cell_count'] < best['cell_count']:
                best = ppa; best_code = code
            feedback = f'Iteration {i}: {ppa}. Best so far: {best}. Improve for mode={args.mode}, delay target <= {target}. Return only Verilog.'
        except Exception as e:
            feedback = 'Synthesis failed. Fix syntax and module/port requirements. Return only Verilog. Error:\n' + str(e)[:1500]
        history += [{'role':'assistant','content':code},{'role':'user','content':feedback}]
    Path(f'best_adder_{args.mode}.v').write_text(best_code)
    Path(f'optimization_log_{args.mode}.json').write_text(json.dumps({'best_ppa':best,'iterations':results}, indent=2))
    print('Best:', best)
if __name__ == '__main__': main()
