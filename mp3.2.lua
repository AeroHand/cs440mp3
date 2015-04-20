function readtrain()
  local f = assert(io.open("train_email.txt", 'r'))
  email={}
  e={}
  for i=1,700 do
     email[i]=f:read("*line")
     e[i]={}
     e[i][1]=tonumber(string.sub(email[i],1,1))
     zhizheng=3
     for point=3,string.len(email[i]),1 do
     	temp=string.sub(email[i],point,point)
     	if temp==":" then
     	   word=string.sub(email[i],zhizheng,point-1)
     	   print(word)
     	   zhizheng=point+1
     	end
        
        if temp==" " then
           e[i][word]=tonumber(string.sub(email[i],zhizheng,point-1))
           print(e[i][word])
           zhizheng=point+1
        end
     end
  end
  f:close()
end	

readtrain()