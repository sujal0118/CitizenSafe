# Use the official Tomcat image
FROM tomcat:10.1.24-jdk17

# Copy the WAR file to Tomcat's webapps directory
COPY target/FraudDetectionSystem-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]
