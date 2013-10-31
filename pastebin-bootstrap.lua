-- put me on pastebin
-- downloads and runs the real turtle loader

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

dl("installer")
shell.run("installer")
