 # FROM부터 다음 FROM 전까지는 builder stage라는 것을 명시
FROM node:alpine as builder

ENV CHOKIDAR_USEPOLLING=true

WORKDIR /usr/src/app

COPY package.json ./

RUN npm install

COPY ./ ./

CMD [ "npm", "run", "build" ]


# nginx를 위한 베이스 이미지
FROM nginx 

# builder로 부터 가져옴
# builder state에서 생성된 파일들은 /usr/src/app/build에 들어가게 되며 
# 그곳에 저장된 파일들을 /usr/share/nginx/html로 복사를 시켜줘서
# nginx가 웹 브라우저의 http 요청이 올 때마다 알맞은 파일을 전해줄 수 있게 만든다.
# nginx는 80이 기본 포트이다.
COPY --from=builder /usr/src/app/build /usr/share/nginx/html