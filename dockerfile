# Use official Tomcat image
FROM tomcat:10.1.24-jdk17

# Set environment variables
ENV CATALINA_HOME /usr/local/tomcat

# Copy the WAR file to Tomcat's webapps directory
COPY target/ROOT.war $CATALINA_HOME/webapps/ROOT.war

# Expose port 8080
EXPOSE 8080

# Start Tomcat server
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]
