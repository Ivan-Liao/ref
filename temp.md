Here is the context.  This is a streaming pipeline in the Azure cloud ecosystem.  A virtual machine has a MariaDB service running.  This virtual machine is on a VNET.  In the same VNET, we created a subnet with subnet delegation Microsoft.MessagingConnectors/connector.  We created a Fabric workspace called FabricProd and activated the workspace identity.  This identity was given the network contributor role to the VNET mentioned earlier.  We created a Fabric data streaming gateway linked to the subnet mentioned earlier.  We created a Fabric connection lets call it biorx-conn linked to the VM IP address.  We tried to create an eventstream with the connection biorx-conn.  The following is the error message.

```
Unable to connect: Access denied for user 'sffabriccdc'@'10.20.36.196' (using password: YES)
```

We have verified that it's not a username and password combination error by using another username and password combination that works for a Synapse linked service.  

What are possible issues?