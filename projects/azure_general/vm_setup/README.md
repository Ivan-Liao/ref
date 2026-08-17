1. Create a resource
2. windows 11 Enterprise
3. Create a virtual machine config
   1. Azure subscription 1
   2. RESOURCE_GROUP_HERE
   3. VM_NAME_HERE
   4. Availability zone
   5. Security type: Confidential virtual machine
   6. Select VM size: ~200/month
   7. Admin account credential setup
   8. Public IP: (new) sfexternaldesktop-ip
   9. Public inbound ports: Allow selected ports
   10. Select inbound ports: RDP(3389)
   11. Delete public IP and NiC ...: checkbox yes
4.  Create new inbound port rule
    1.  Source: My IP address
    2.  Service: RDP
    3.  Protocol: TCP
    4.  Destination port ranges: 3389