# DevOps

# Real Time END to END Automation Deployment Config Files has been Available for further use cases..!

## All these codes are developed from scratch for many real time workflow usecases

### Tech Stacks Code Available :

  - Amazon Web Services(AWS)
  - Kubernetes
  - Terraform
  - Jenkins
  - Linux Shell Scripts
  - GCP

## Bastion Host Access

## How to access all other nodes from Bastion Instance.

### Linux:

### Commands to follow:

-	ssh-add -l (It will list out any key identity added on system)

-	ssh-add path-to-pem-file (It will add the pem file as an identity which we can use for all our ssh connection inside ec2 instance).

-	ssh -A ubuntu@Bastion-Public-IP

-	Once accessed the bastion,then you can directly ssh into any instance without providing key file.

-	ssh Private-IP or naming per host

### Windows:


### Configuring ssh-agent on Windows

  
In Windows, you can connect to Linux VPC instances using PuTTY. To get SSH agent functionality, you can use Pageant, which is available from the PuTTY download page. When Pageant is installed, you can use the agent forwarding option in PuTTY to connect to instances in private subnets.
To use Pageant, you need to convert your private key from PEM format to PuTTY format using PuTTYGen (available from the PuTTY(download page). In PuTTYGen, choose Conversions>Import Key and select your PEM-formatted private key. Enter a passphrase and then click Save private key, as shown in the following screenshot. Save the key as a .ppk file.
  
 ![image](https://user-images.githubusercontent.com/89067424/129779831-4d537a16-53cd-4b04-b9a7-545806853c4e.png)

 
After you convert the private key, open Pageant, which runs as a Windows service. To import the PuTTY-formatted key into Pageant, double-click the Pageant icon in the notification area and then click Add Key. When you select the .ppk file, you’re prompted to enter the passphrase you chose when you converted the key, as shown in the following screenshot.
  
  ![image](https://user-images.githubusercontent.com/89067424/129779878-d3a02a08-2ae6-415d-96b1-b78386c9d326.png)

 
After you add the key, close the Pageant Key List window.
Finally, when you are configuring the connections for SSH in PuTTY, check the Allow agent forwarding box and leave the Private key file for authentication field empty.
When you use PuTTY to connect to the public IP address of your bastion, you will see that the Pageant PuTTY component provides the SSH key for authentication, as shown in the following screenshot.
  
  ![image](https://user-images.githubusercontent.com/89067424/129779917-fd5cd7bc-20f0-4f4d-8fc0-1491110b7fef.png)

 
With agent forwarding enabled in the PuTTY configuration, you can connect from the bastion to any other instance in the VPC without having the SSH private key on the bastion. To connect to other instances, use the following command:
ssh user@<instance-IP-address or DNS-entry>
As long as the matching private key for the instance is loaded into Pageant, the connection will be successful, as shown in the following screenshot.

  ![image](https://user-images.githubusercontent.com/89067424/129779442-cf8e0b6b-8179-4f1a-91b7-81a619909d88.png)
