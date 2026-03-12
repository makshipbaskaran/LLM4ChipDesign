def priority_encoder4_golden(req):
    # Initialize outputs
    code = 0
    valid = 0

    # Determine the highest priority request
    if req & 0b1000:
        code = 0b11
        valid = 1
    elif req & 0b0100:
        code = 0b10
        valid = 1
    elif req & 0b0010:
        code = 0b01
        valid = 1
    elif req & 0b0001:
        code = 0b00
        valid = 1

    # Return the outputs as a dictionary
    return {'code': code, 'valid': valid}