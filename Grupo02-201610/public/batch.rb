#!/usr/bin/env ruby
require 'rubygems'
require 'rmagick'

FNAME = "uploads/disenio/picture/17/Posible1.jpg"

WIDTH = 800
HEIGHT = 600

# the Magick class used for annotations
gc = Magick::Draw.new
gc.font_family = 'helvetica'
gc.pointsize = 12
gc.font_weight = Magick::BoldWeight
gc.gravity = Magick::SouthGravity

# g.fill = 'white'
# g.undercolor = 'black'

# the base image
img = Magick::Image.read(FNAME)[0].strip!
ximg = img.resize_to_fit(WIDTH, HEIGHT)

# label the image with the method name
#lbl = Magick::Image.new(WIDTH, HEIGHT)
gc.annotate(ximg, 0, 0, 0, 0, "MENSAJE")

# save the new image to disk
new_fname = "#{FNAME}-Distinta.png"
ximg.write((new_fname))
