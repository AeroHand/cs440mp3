function readtrain()
  local f = assert(io.open("traininglabels", 'r'))
  for i=1,5000 do
     tl[i]=f:read("*number")
  end
  f:close()

  local f=assert(io.open("trainingimages", 'r'))   
  feature={}
  for i=0,9 do
     feature[i]={}
     for j=1,28 do
       feature[i][j]={}
       for k=1,28 do
          feature[i][j][k]=0
       end   
     end
  end
  count={}
  for i=0,9 do
    count[i]=0
  end
  for i=1,5000 do
    local templable=tl[i]
    count[templable]=count[templable]+1
    for j=1,28 do
      local line=f:read("*line")
      --print(line)
      for k=1,28 do
        local tempc=string.sub(line,k,k)
        if not(tempc==" ") then
          feature[templable][j][k]=feature[templable][j][k]+1
        end  
      end  
    end
  end  

  f:close()
end

function printtable()
  for i=0,9 do
    print(i)
    for j=1,28 do
      local line=""
      for k=1,28 do
        line=line..feature[i][j][k].." "
      end
      print(line) 
    end
  end  
end

function smooth()
  for i=0,9 do
    for j=1,28 do
      for k=1,28 do
        feature[i][j][k]=(feature[i][j][k]+laplacek)/(count[i]+laplacek*count[i])
      end
    end
  end    
end  


tl={}  --training label table
laplacek=1
readtrain()
smooth()

printtable()