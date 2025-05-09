FROM node:22
WORKDIR /app
# COPY package.json /app   is same as COPY package.json .
# it means copy package.json into /app
COPY package.json /app
RUN npm install
COPY .  /app
ENV PORT 3000
EXPOSE $PORT
CMD ["node", "index.js"]