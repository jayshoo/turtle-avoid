-- the bootstrap fetches this script so updates can come thru
-- downloads the other scripts from github to the turtle

prefix = "https://raw.github.com/jayshoo/turtle-avoid/master/"

function dl(file, target)
  -- if one argument, default to same filename
  if not target then target = file end
  
  url = prefix..file
  resp = http.get(url)
  
  file = fs.open(target, "w")
  file.write(resp.readAll())
  
  file.close()
  resp.close()
end

dl("startup")
dl("avoider")
shell.run("avoider")
