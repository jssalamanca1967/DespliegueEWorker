class Awsmailer < ApplicationMailer


  def enviar(disenio)
    puts "Me llamaron!!!"

    @disenio = disenio
    ses = AWS::SimpleEmailService.new(
      :access_key_id => 'AKIAIGZG6B65YJGC7QBQ',
      :secret_access_key => '7JYRUSZfzWbYySR4ztdDJ8414OWCACvSwuanej/7')

    asdf = ses.send_email(
      :subject => 'A Sample Email',
      :to => ['johnathansalamanca@gmail.com', 'js.salamanca1967@uniandes.edu.co'],
      :from => 'designmatch@outlook.com',
      :body_text => 'sample text ...')

    puts asdf

    #ses.send_raw_email(<<EMAIL, :to => @disenio.email_diseniador, :from => 'designmatch2@gmail.com')
    #Subject: A Sample Email

    #Sample email text.
    #EMAIL

  end

end
