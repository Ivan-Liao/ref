# Use the latest Ubuntu image as the base
FROM ubuntu:latest

# Install figlet for ASCII art
RUN apt-get update && apt-get install -y figlet wget

# Download and install the Star Wars font for figlet
RUN wget http://www.jave.de/figlet/fonts/details/starwars.flf -O /usr/share/figlet/starwars.flf
RUN wget http://www.jave.de/figlet/fonts/details/flowerpower.flf -O /usr/share/figlet/flowerpower.flf

# Copy the ASCII art script to the container
COPY print-message.sh /print-message.sh

# Make sure the script is executable
RUN chmod +x /print-message.sh

# Set the command to run the ASCII art script
CMD ["/print-message.sh"]