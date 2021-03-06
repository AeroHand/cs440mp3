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
  for i=1,30 do
    print(i)
    for j=1,28 do
      local line=""
      for k=1,28 do
        line=line..testf[i][j][k].." "
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

function smoothtest()
  for i=1,500 do
    for j=1,28 do
      for k=1,28 do
        testf[i][j][k]=(testf[i][j][k]+laplacek)/(500+laplacek*500)
      end
    end
  end    
end  

function readtest()
 local f = assert(io.open("testlabels", 'r'))
  for i=1,500 do
     testl[i]=f:read("*number")
  end
  f:close()

  local f=assert(io.open("testimages", 'r'))   
  testf={}
  for i=1,500 do
     testf[i]={}
     for j=1,28 do
       testf[i][j]={}
       for k=1,28 do
          testf[i][j][k]=0
       end   
     end
  end

  for i=1,500 do
    for j=1,28 do
      local line=f:read("*line")
      --print(line)
      for k=1,28 do
        local tempc=string.sub(line,k,k)
        if not(tempc==" ") then
          testf[i][j][k]=testf[i][j][k]+1
        end  
      end  
    end
  end  

  f:close()  
end

function printlabel()
  for i=1,500 do
    --print(testresult[i])
  end
end

function test()
  p={}
  for i=0,9 do
    p[i]=count[i]/5000
  end
  
  testresult={} --record the test result
  for i=1,500 do
    local max=nil
    local curlable=0
    for j=0,9 do
      sum=math.log(p[j])
      --sum=0
      for k=1,28 do
        for l=1,28 do
          if testf[i][k][l]==0 then
            albb=0
          else
            albb=testf[i][k][l]
          end  
          local ttt=albb*feature[j][k][l]
          if not(ttt==0) then
            sum=sum+math.log(ttt)
          --else
          --  sum=sum+math.log(notexist)
          end  
          --print(sum)
        end
      end
      if not(max) then
        max=sum
        curlable=j
      end  
      if sum>max then
        max=sum
        curlable=j
      end
    end
    testresult[i]=curlable
  end      
end  


function eval()
  local ccount={}

  local confusionmatrix={}
  for i=0,9 do
    confusionmatrix[i]={}
    for j=0,9 do
      confusionmatrix[i][j]=0
    end  
  end  
  for i=0,9 do
    ccount[i]=0
  end  
  for i=1,500 do
    if not(testresult[i]==testl[i]) then
      ccount[testl[i]]=ccount[testl[i]]+1
      confusionmatrix[testl[i]][testresult[i]]=confusionmatrix[testl[i]][testresult[i]]+1
    end
  end
  sum=0
  axb=0
  for i=0,9 do
    sum=sum+ccount[i]
    axb=axb+count[i]
    print(i,":",(1-ccount[i]/count[i]))
  end
  
  for i=0,9 do
    local tobeprint=""
    for j=0,9 do
      local temp=confusionmatrix[i][j]/count[i]
      local ttt=string.format("%.2f", math.floor(temp*10000)/100)
      tobeprint=tobeprint..ttt.."% "
    end
    print(tobeprint)
  end    
  print(1-sum/axb)    
end

function odd(a,b)
  print("odd of number",a,"and",b,":")
  for i=1,28 do
    local tobprint=""
    for j=1,28 do
      tempodd=math.log(testf[a][i][j]/testf[b][i][j])
      if tempodd>2 then
        tobprint=tobprint.."+"
      else
        if tempodd<0 then
          tobprint=tobprint.."-"
        else
          tobprint=tobprint.." "
        end
      end
    end
    print(tobprint)
  end          
end  

--main
tl={}  --training label table
testl={} --test label table
laplacek=50
readtrain()
smooth()
readtest()
test()
eval()
odd(2,8)
odd(6,8)
odd(5,8)
odd(7,8)