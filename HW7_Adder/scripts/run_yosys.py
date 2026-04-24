import os, re, json, subprocess, sys

def synthesize(verilog_file, top_module):
    env = os.environ.copy()
    env['ADDER_FILE'] = verilog_file
    env['TOP_MODULE'] = top_module
    proc = subprocess.run(['yosys', '-s', 'synth_adder.ys'], capture_output=True, text=True, env=env)
    log = proc.stdout + proc.stderr
    if proc.returncode != 0:
        raise RuntimeError(log)
    return parse_stats(log), log

def parse_stats(log):
    ppa = {'cell_count': None, 'area_um2': None, 'logic_levels': None}
    m = re.search(r'Number of cells:\s+(\d+)', log)
    if m: ppa['cell_count'] = int(m.group(1))
    m = re.search(r'Chip area for.*?:\s+([\d.]+)', log)
    if m: ppa['area_um2'] = float(m.group(1))
    m = re.search(r'Longest topological path.*?\((\d+) levels?\)', log, re.S)
    if m: ppa['logic_levels'] = int(m.group(1))
    return ppa

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print('Usage: python run_yosys.py <verilog_file> <top_module>')
        sys.exit(1)
    ppa, log = synthesize(sys.argv[1], sys.argv[2])
    print(json.dumps(ppa, indent=2))
