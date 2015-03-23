#utility stuff
class Util

  # a and b are matrices
  # as arrays of length 9:
  # [ a b c
  #   d e f
  #   g h i ]
  convolve: (a, b) ->
    output = [9]
    for i in [0..8]
      output[i] = a[i] * b[i]
    return output

  # a and b are matrices
  # as arrays of length 9:
  # [ a b c
  #   d e f
  #   g h i ]  
  matrix_sum: (a, b) ->
    output = [9]
    for i in [0..8]
      output[i] = a[i] + b[i]
    return output

  # returns average value of matrix
  matrix_magnitude: (matrix) ->
    output = 0
    for i in [0..8]
      output = output + matrix[i]
    return output

module.exports = Util