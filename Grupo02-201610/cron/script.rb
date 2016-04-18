#!/usr/bin/ruby
require "rubygems"

connection = Fog::Storage.new({
  :provider                 => 'AWS',
  :aws_access_key_id        => ENV["AWSAccessKeyId"],
  :aws_secret_access_key    => ENV["AWSSecretKey"],
  :region		    => "us-west-2",
  :persistent		    => true
})
directorio=connection.directories.get(ENV["AWSBucket"])

sqs = Aws::SQS::Client.new(
          region: 'us-west-2',
          access_key_id: ENV['AWSAccessKeyId'],
          secret_access_key: ENV['AWSSecretKey']
      )
#resp = sqs.receive_message({
#  queue_url: "https://sqs.us-west-2.amazonaws.com/364477857468/mensajes", # required
#  max_number_of_messages: 1,
#  visibility_timeout: 1,
#  wait_time_seconds: 1,
#})

poller = Aws::SQS::QueuePoller.new('https://sqs.us-west-2.amazonaws.com/364477857468/mensajes', client: sqs)
poller.poll do |resp|
  mensaje = JSON.parse(resp.body)

  print("---------REGISTRO---------")
  iddiseniador = mensaje["d_id"]
  direccion = mensaje["d_direccion"]
  correo = mensaje["d_correo"]
  nombre = mensaje["d_nombrediseniador"]
  fecha = mensaje["d_fechacreacion"]
  print("Paso Direccion con correo #{correo}\n")

  width = 800
  height = 600

  # the Magick class used for annotations
  gc = Magick::Draw.new
  gc.font = 'helvetica'
  gc.pointsize = 12
  gc.font_weight = Magick::BoldWeight
  gc.gravity = Magick::SouthGravity
  gc.fill = 'white'
  gc.undercolor = 'black'

  s3_file = directorio.files.get(direccion)
  local_file = File.open("output","w+b")
  local_file.write(s3_file.body)
  local_file.close

  img_file = File.open("output", "r")
  # the base image
  img = Magick::Image.read(img_file)[0].strip!
  print("[DESARROLLADOR] Lectura de la imagen\n")
  ximg = img.resize_to_fit(width, height)
  print("[DESARROLLADOR] Resize\n")
  # label the image with the method name

  print("[DESARROLLADOR] #{fecha}")
  mensaje = "#{nombre} ::: #{fecha}"

  lbl = Magick::Image.new(width, height)
  gc.annotate(ximg, 0, 0, 0, 0, mensaje)

  ## save the new image to disk
  new_file_bucket = "#{direccion}-[PROCESADA].png"
  new_fname = "output.png"
  ximg.write((new_fname))
  img_file.close

  #local_file_md5 = Digest::MD5.file("output.png")
  s3_file_object = directorio.files.create(:key => new_file_bucket, :body => File.open("output.png"), :acl => "public-read")

  #newimg = directorio.files.new(new_file_bucket)
  #newimg.body = File.open("output.png")
  #newimg.acl = 'public-read'
  #newimg.save

  print("PROCESANDO #{direccion}\n")
  @disenio = Diseniody.find(iddiseniador)
  @disenio.estado = "Disponible"
  @disenio.save

#SenderMail.enviar(@disenio).deliver_now

  SenderMail.enviarHeroku(correo, nombre, fecha).deliver_now

  # ses = Aws::SES::Client.new(
  #     region: 'us-west-2',
  #     access_key_id: ENV['AWSAccessKeyId'],
  #     secret_access_key: ENV['AWSSecretKey']
  # )
  #
  # resp2 = ses.send_email({
  #     source: "designmatch@outlook.com", # required
  #     destination: { # required
  #         to_addresses: ["#{correo}", "js.salamanca1967@uniandes.edu.co"],
  #     },
  #     message: { # required
  #         subject: { # required
  #             data: "Tu disenio esta listo",
  #         },
  #         body: { # required
  #             text: {
  #                 data: "Leeeeel",
  #             },
  #             html: {
  #                 data: "<h1>Hola #{nombre}</h1><br><p>Tu disenio, creado el #{fecha} para el proyecto ya esta disponible.</p>",
  #             },
  #         },
  #     },
  # })
end
