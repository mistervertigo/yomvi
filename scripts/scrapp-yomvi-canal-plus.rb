require 'open-uri'
require 'nokogiri'

url = "http://www.plus.es/canal/---/cpser"
html = open(url).read
entry = Nokogiri::HTML(html)

url2 = "http://www.plus.es/canal/---/cp"
html2 = open(url2).read
entry2 = Nokogiri::HTML(html2)

#Creo HTML con el contenido
File.open('../esta-noche-yomvi-canal-plus.html', 'w') do |f2|

  #Pinto el código HTML
  f2.puts "<!DOCTYPE html>
<html lang='en'>
  <head>
    <meta charset='utf-8'>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>Esta noche en Canal +</title>
    <link rel='stylesheet' href='css/bootstrap.min.css'>
    <link rel='stylesheet' href='css/main.css'>
    
  </head>

  <body>"
  #Uso la clase TIME de ruby http://www.ruby-doc.org/core-2.1.2/Time.html
  t = Time.now
  dia_sem = t.strftime("%A")
  dia_mes = t.strftime("%d")
  mes_ano = t.strftime("%B")
  ano_ano = t.strftime("%Y")
  f2.puts "
  <div class='jumbotron'>
        <div class='container'>
          <h1>Esta noche en Yomvi</h1>
          <p>#{dia_sem}, #{dia_mes} de #{mes_ano} #{ano_ano}</p>
          </div>
  </div>
  <div class='container'>
     <div class='row'>"
     
     #Creo bucle con el parsing del HTML de C+ 1
   f2.puts "
     <div class='col-md-6'>
           <h3>Cine <small>Canal + 1</small></h3>"
           entry2.search(".destacado_item").each do |x|
             
             #Defino la hora, la limpio y la paso a integer para comparala
             program_hour = x.at_css(".horario").text.gsub(':','').gsub('h','').to_i
             #Defino y parseo la hora ofcial de la pelicula
             friendly_hour = x.at_css(".horario").content.strip
             #Defino y parseo el género de la pelicula, en series no suele existir
             type = x.at_css(".tag").text
             #Defino y parseo el canal a parir del title de una imagen
             channel = x.at_css(".dial img")['title']
             #Defino y parseo el título de a película o programa
             program = x.at_css(".destacado_cont a[href]").text
             #Defino y parseo el thumb del programa
             image = x.at_css("a:first-child img")['src']
    
             #Solo quiero mostrar programas a partir de las 20:30 y los que sean a las 00:00 (al convertirlo a integer y por seguridad muestro 0)
             if program_hour >= 2030 || program_hour == 0 || program_hour == 0000
               f2.puts "<div class='item clearfix'>
                   <img class='pull-left img-thumbnail' src='http://www.plus.es/#{image}' />
                   <p class='time'><strong>#{friendly_hour}</strong> | #{type}</p>
                   <h2 class='text-primary'>#{program}</h2>
                   <p class='text-muted'>#{channel}</p>
               </div>"
             end
           end
  f2.puts "</div>"
  #Creo bucle con el parsing del HTML de C+ Series, el resto es igual que películas (nota: crear un método para no repetir código)
  f2.puts "<div class='col-md-6'>
          <h3>Series <small>Canal + Series</small></h3>"
           entry.search(".destacado_item").each do |x|
    
             program_hour = x.at_css(".horario").text.gsub(':','').gsub('h','').to_i
             friendly_hour = x.at_css(".horario").content.strip
             channel = x.at_css(".dial img")['title']
             program = x.at_css(".destacado_cont a[href]").text
             image = x.at_css("a:first-child img")['src']
       
             
               if program_hour >= 2030 || program_hour == 0 || program_hour == 0000
                 f2.puts "<div class='item clearfix'>
                   <img class='pull-left img-thumbnail' src='http://www.plus.es/#{image}' />
                   <p class='time'><strong>#{friendly_hour}</strong></p>
                   <h2 class='text-primary'>#{program}</h2> 
                   <p class='text-muted'>#{channel}</p>
                 </div>"
               end
             
           end
  f2.puts "</div>"
  
  f2.puts "<div class='footer clearfix'><hr> Fuentes: <a href='#{url2}'>#{url2}</a> & <a href='#{url}'>#{url}</a></div>"
  
  f2.puts "
        </div>
      </div>
    </body>
</html>"

end
