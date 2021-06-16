echo 'dotnet start'

echo '1、env'
pwd
ls
whoami
which dotnet
dotnet --info
dotnet --version

echo '2、cd WebApplication1'
cd ./WebApplication1

echo '3、dotnet restore WebApplication1'
dotnet restore

echo '4、delete and add directory WebApplication1_Publish'
rm -rf $WORKSPACE/WebApplication1_Publish
mkdir $WORKSPACE/WebApplication1_Publish

echo '5、dotnet publish WebApplication1'
dotnet publish -c:Release -o $WORKSPACE/WebApplication1_Publish

echo 'dotnet end'

echo '6、cd WebApplication1_Publish'
cd $WORKSPACE/WebApplication1_Publish

echo 'docker start'

echo '7、add Dockerfile'
touch Dockerfile
echo "FROM microsoft/dotnet" >> Dockerfile
echo "WORKDIR /app" >> Dockerfile
echo "COPY . ." >> Dockerfile
echo "EXPOSE 8088" >> Dockerfile
echo "ENV ASPNETCORE_URLS http://*:8088" >> Dockerfile
echo "ENV ASPNETCORE_ENVIRONMENT Production" >> Dockerfile
echo "ENTRYPOINT [\"dotnet\", \"WebApplication1.dll\"]" >> Dockerfile

echo '8、stop container WebApplication1'
sudo docker stop $(sudo docker ps -a -q  --filter=ancestor=WebApplication1) || :

echo '9、delete container WebApplication1'
sudo docker rm $(sudo docker ps -a -q --filter=ancestor=WebApplication1) || :

echo '10、delete image WebApplication1'
sudo docker rmi WebApplication1 || :

echo '11、build image WebApplication1'
sudo docker build -t WebApplication1 .

echo '12、run container WebApplication1'
sudo docker run -p 8088:8088 -d --name WebApplication1 WebApplication1

echo 'docker end'
