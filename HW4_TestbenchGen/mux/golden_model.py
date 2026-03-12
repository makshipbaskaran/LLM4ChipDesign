def mux2to1_golden(a, b, sel):
    y = a if sel == 0 else b
    return {'y': y}