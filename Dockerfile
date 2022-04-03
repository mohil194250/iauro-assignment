FROM node:8
WORKDIR /home/ubuntu/BackendDemoProject
COPY . .
RUN npm install --production
CMD [“node”, “node_server.js”]
