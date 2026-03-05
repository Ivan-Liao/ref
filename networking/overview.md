- [metaphor](#metaphor)
    - [1. IP Addresses: The "Mailing Address"](#1-ip-addresses-the-mailing-address)
    - [2. Port Forwarding: The "Internal Extension"](#2-port-forwarding-the-internal-extension)
    - [3. Proxies: The "Front Desk / Security Guard"](#3-proxies-the-front-desk--security-guard)
    - [4. URL Map: The "Building Directory"](#4-url-map-the-building-directory)
    - [How they connect in a real-world request:](#how-they-connect-in-a-real-world-request)

# metaphor
In networking, these components work together like a postal system to ensure a request from a user's browser reaches the correct application on a server. Think of it as a journey from the **General Location (IP)** to the **Specific Building (Proxy/URL Map)** and finally the **Exact Room (Port).**

---

### 1. IP Addresses: The "Mailing Address"

An **IP Address** is a unique identifier for a device on a network.

* **Public IP:** The address of your entire house or office building as seen by the world.
* **Private IP:** The address of a specific device (like a laptop or server) *inside* that building.
* **The Relation:** Every request starts by looking up an IP address via DNS. Without the IP, the packet has no destination.

1. IP address standard conventions
   1. <8 bit>.<8 bit>.<8 bit>.<8 bit>/<0-32 int>
      1. e.g. 192.168.1.0/24
   2. the /<0-32 int> means how many bits are reserved for the network and how many are available for the host
      1. /24 means the last 8 bits are available for the hosts, which is actually 254 since .0 is the network id and .255 is the broadcast ip (sends message to all devices at the same time)
      2. 192.168.1.1 (Typically the Default Gateway/Router)
      3. 192.168.1.2 (Secondary Router or Switch)
      4. 192.168.1.10 (Static IP for a Database Server)
      5. 192.168.1.11 (Static IP for a Load Balancer)
      6. 192.168.1.20 (Network Printer)
      7. 192.168.1.30 (NAS / Storage Server)
      8. 192.168.1.50 (VPN Gateway)
      9. 192.168.1.250 (Management Interface for an ESXi host)
      10. 192.168.1.253 (Intrusion Detection System)
      11. 192.168.1.254 (Backup Gateway)
      12. 192.168.1.101 (User Laptop)


### 2. Port Forwarding: The "Internal Extension"

A **Port** is a communication endpoint (like an extension number). Servers usually have thousands of available ports.

* **Standard Ports:** Web traffic usually hits Port 80 (HTTP) or 443 (HTTPS).
* **Port Forwarding:** This is a rule on a router or firewall that says: *"Any traffic hitting our Public IP on Port 8080 should be sent to Server A at Private IP 192.168.1.5 on Port 80."*
* **The Relation:** It bridges the gap between the Public IP and the Private IP of the specific machine running your code.

### 3. Proxies: The "Front Desk / Security Guard"

A **Proxy** (specifically a Reverse Proxy like Nginx or a Cloud Load Balancer) sits between the user and the server.

* **What it does:** It receives the request first. It can provide security (SSL termination), caching, or hide the identity of the backend servers.
* **The Relation:** Instead of the user connecting directly to a database or app server, they connect to the Proxy. The Proxy then uses its own internal logic to decide which backend server to talk to.

### 4. URL Map: The "Building Directory"

A **URL Map** (often used in Cloud Load Balancers like GCP's) is a set of rules that routes traffic based on the **URL path**.

* **The Logic:**
* `example.com/images/*` $\to$ Route to **Storage Bucket**
* `example.com/api/*` $\to$ Route to **App Server Cluster**
* `example.com/video/*` $\to$ Route to **Video Processing Service**


* **The Relation:** It is the "brain" inside the Proxy/Load Balancer. It takes a single IP address and splits the traffic based on what the user is actually looking for.

---

### How they connect in a real-world request:

1. **User** types `figma.com/api/v1` into a browser.
2. **DNS** resolves `figma.com` to a **Public IP Address**.
3. The request hits a **Proxy** (Load Balancer) at that IP.
4. The **URL Map** sees the `/api/` path and realizes this is a backend request.
5. The Proxy uses **Port Forwarding** (or internal routing) to send that request to a specific internal server on **Port 8080**.
6. The **Server** processes the data and sends it back through the same chain.

**Would you like me to explain how "Sticky Sessions" work within this flow to keep a user connected to the same server?**