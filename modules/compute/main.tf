# Launch Configuration for Web Tier
resource "aws_launch_configuration" "web_server" {
  name_prefix     = "web-server-"
  image_id        = var.image_id
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.web.id]




  user_data = <<-EOF
    #!/bin/bash

    # Update system and install Python 3 and pip
    sudo yum update -y
    sudo yum install -y python3
    sudo yum install mariadb-server
    sudo systemctl start mariadb
    sudo mysql_secure_installation
    # Install pip for Python 3
    curl -O https://bootstrap.pypa.io/get-pip.py
    sudo yum install python3-pip

    # Install Flask and mysql-connector
    sudo pip3 install Flask mysql-connector-python

    # Create directories for the Flask app
    mkdir -p /opt/myflaskapp/templates

    # Set proper permissions
    sudo chown -R ec2-user:ec2-user /opt/myflaskapp
    sudo chmod -R 755 /opt/myflaskapp

    # Write the Flask application to /opt/myflaskapp
    cat > /opt/myflaskapp/app.py << 'EOT'
    #!/usr/bin/env python3

    from flask import Flask, render_template, request
    import mysql.connector

    app = Flask(__name__)

    # Database configuration
    config = {
      'user': 'admin',
      'password': 'strongpassword123',
      'host': 'terraform-20240423011607926100000005.cbm66cuqeddm.ca-central-1.rds.amazonaws.com',
      'database': 'new_db_name',
    }

    def ensure_tables_exist():
      table_query = """
      CREATE TABLE IF NOT EXISTS messages (
          id INT AUTO_INCREMENT PRIMARY KEY,
          content VARCHAR(255) NOT NULL
      );
      """
      try:
          cnx = mysql.connector.connect(**config)
          cursor = cnx.cursor()
          cursor.execute(table_query)
          cnx.commit()
          cursor.close()
          cnx.close()
      except mysql.connector.Error as err:
          print("Failed to ensure tables exist: {}".format(err))

    @app.route('/')
    def index():
      return render_template('index.html')  # Serve a page with a form

    @app.route('/submit', methods=['POST'])
    def submit():
      user_input = request.form['content']
      try:
          cnx = mysql.connector.connect(**config)
          cursor = cnx.cursor()
          cursor.execute("INSERT INTO messages (content) VALUES (%s)", (user_input,))
          cnx.commit()
          cursor.execute("SELECT content FROM messages")
          entries = cursor.fetchall()
          cursor.close()
          cnx.close()
          return render_template('entries.html', entries=entries)
      except mysql.connector.Error as err:
          return f"Failed to interact with the database: {err}"

    if __name__ == '__main__':
      ensure_tables_exist()  # Check and create tables if needed before running the server
      app.run(host='0.0.0.0', port=80)
    EOT

    # Copy HTML templates
    cat > /opt/myflaskapp/templates/index.html << 'EOT'
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Submit Content</title>
    </head>
    <body>
        <h1>Submit New Content</h1>
        <form action="/submit" method="post">
            <label for="content">Enter some content:</label>
            <input type="text" id="content" name="content">
            <input type="submit" value="Submit">
        </form>
    </body>
    </html>
    EOT

    cat > /opt/myflaskapp/templates/entries.html << 'EOT'
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>View Entries</title>
    </head>
    <body>
        <h1>All Entries</h1>
        {% if entries %}
            <ul>
            {% for entry in entries %}
                <li>{{ entry[0] }}</li>
            {% endfor %}
            </ul>
        {% else %}
            <p>No entries found.</p>
        {% endif %}
        <a href="/">Submit Another Content</a>
    </body>
    </html>
    EOT

    # Start the Flask application
    cd /opt/myflaskapp
   nohup python3 app.py > /dev/null 2>&1 &
EOF

}


# Auto Scaling Group for Web Tier
resource "aws_autoscaling_group" "web" {
  launch_configuration = aws_launch_configuration.web_server.id
  min_size             = var.min_size
  max_size             = var.max_size
  vpc_zone_identifier  = var.subnets
  target_group_arns    = [var.target_group_arn]

  tag {
    key                 = "Name"
    value               = "web-instance"
    propagate_at_launch = true
  }
}

# Example Security Group for Web Tier
resource "aws_security_group" "web" {
  name        = "web-sg"
  description = "Security group for web tier allowing HTTP and SSH"
  vpc_id      = var.vpc_id
  # security_groups = [var.db_security_group_id]


  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description = "HTTP"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
