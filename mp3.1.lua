function readtrain()
  local f = assert(io.open("traininglabels", 'r'))
  for i=1,5000 do
     tl[i]=f:read("*number")
  end
  f:close()

  local f=assert(io.open("trainingimages", 'r'))   
  feature={}
  for i=1,10 do
     feature[i]={}
     for j=1,28 do
       feature[i][j]={}
     end
  end
  
  for i=1,5000 do
    local templable=tl[i]
    for j=1,28 do
      local line=f:read("*line")
      for k=1,28 do
        print(line[k])
      end  
      print(line)
    end
  end  

  f:close()
end

tl={}  --training label table
readtrain()