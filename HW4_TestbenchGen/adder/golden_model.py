def adder4bit_golden(a, b):
    # Ensure inputs are within 4-bit range
    a = a & 0xF
    b = b & 0xF
    
    # Perform addition
    total = a + b
    
    # Calculate sum and carry
    sum_result = total & 0xF
    carry = 1 if total > 0xF else 0
    
    # Return results as a dictionary
    return {'sum': sum_result, 'carry': carry}