-- put me on pastebin or a floppy
-- downloads and runs the real turtle loader

prefix = "https://raw.github.com/jayshoo/turtle-avoid/master/"

function dl(file, target)
  -- if one argument, default to same filename
  if not target then target = file end
  
  url = prefix..file..".lua"
  resp = http.get(url)
  
  fp = fs.open(target, "w")
  fp.write(resp.readAll())
  fp.close()
  
  resp.close()
end

dl("installer")
shell.run("installer")
