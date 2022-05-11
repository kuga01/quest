ARG SECRET_WORD=TwelveFactor
FROM node:10-alpine

ENV SECRET_WORD = $SECRET_WORD

# Working Directory
WORKDIR /usr/src/rearc

# Copy project files to current working directory
COPY ./src ./src
COPY ./bin ./bin
COPY ./package.json ./

# install dependencies
RUN npm install

# Expose container port
EXPOSE 3000

# Set directory for volume
VOLUME /var/lib/rearc

CMD ["node", "./src/000.js"]
