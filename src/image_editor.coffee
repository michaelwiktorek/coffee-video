Util = require "./util.coffee"

util = new Util()

class ImageEditor

  sobel_x: [ -1, 0, 1,
               -2, 0, 2,
               -1, 0, 1 ]

  sobel_y: [ -1, -2, -1,
                0,  0,  0,
                1,  2,  1 ]

  constructor: (number) ->
    @number = number

  sobel_single: (subimage) ->
    # return util.matrix_magnitude(
    #   util.matrix_sum(
    #     util.convolve(@sobel_x, subimage), 
    #     util.convolve(@sobel_y, subimage)
    #     )
    #   )
    a = util.matrix_magnitude(util.convolve(@sobel_x, subimage))
    b = util.matrix_magnitude(util.convolve(@sobel_y, subimage))
    return a + b

  fast_sobel: (m) ->
    a = Math.abs(m[0] + 2 * m[1] + m[2]) - (m[6] + 2 * m[7] + m[8])
    b = Math.abs(m[2] + 2 * m[5] + m[8]) - (m[0] + 2 * m[3] + m[6])
    return a + b

  # apply sobel_single to every 3x3 matrix
  # of pixels in the image
  sobel_filter: (ctx, thresh) ->
    image = ctx.getImageData(0,0,ctx.canvas.width,ctx.canvas.height)
    subimage = [9]
    # iterate over image data
    width = image.width
    height = image.height
    new_image = ctx.createImageData(width, height)
    for i in [0..(width * height - 1)]
      # iterate over square of 9 pixels
      for j in [-1..1]
        for k in [-1..1]
          index = 4 * (i + (j * width) + k)
          r = image.data[index    ]
          g = image.data[index + 1]
          b = image.data[index + 2]
          a = image.data[index + 3]
          subimage[(j + 1) * 3 + (k + 1)] = @luminance(r, g, b, a)
      value = 1.5 * @sobel_single(subimage)
      #value = 1.5 * @fast_sobel(subimage)
      #console.log(value)
      if value < thresh
        value = 0
      new_image.data[index    ] = value
      new_image.data[index + 1] = value
      new_image.data[index + 2] = value
      new_image.data[index + 3] = 255
    #console.log(new_image.data)
    ctx.putImageData(new_image,0,0)

  luminance: (r, g, b, a) ->
    return (0.2126 * r + 0.7152 * g + 0.0722 * b)

  chroma_key: (ctx, r, g, b) ->
    image = ctx.getImageData(0,0,ctx.canvas.width,ctx.canvas.height)
    len = image.data.length / 4
    for i in [0..(len - 1)]
      red = image.data[4 * i   ]
      green = image.data[4 * i + 1]
      blue = image.data[4 * i + 2]
      a = image.data[4 * i + 3]
      if (red < r) and (green < g) and (blue < b)
        image.data[4 * i + 3] = 0
    ctx.putImageData(image,0,0)


module.exports = ImageEditor