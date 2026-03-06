## Laboratorio – DHCP + DNS con Ansible

Playbook sencillo para desplegar y configurar **DHCP (dhcpd)** y **DNS (BIND/named)** en Rocky Linux 9 utilizando Ansible.

### Objetivo

- Levantar un servidor Rocky 9 que actúe como:
  - Servidor DNS autoritativo para un dominio interno.
  - Servidor DHCP para una o varias subredes.
- Hacerlo de forma repetible y fácil de probar con 3 VMs.

### Topología propuesta

- `ansible`: controlador Ansible.
- `server`: servidor Rocky 9 con BIND + DHCP.
- `client`: cliente Rocky 9 que obtiene IP por DHCP y resuelve DNS contra el servidor.

La definición de las 3 VMs (IPs, redes, etc.) se hace con Vagrant en el `Vagrantfile`.

### Estructura del repo

- `site.yml`: playbook principal.
- `inventory/hosts.ini`: inventario estático de las 3 VMs.
- `group_vars/all.yml`: variables globales (dominio, subred, rangos, etc.).
- `roles/dns_bind`: rol para instalar y configurar BIND.
- `roles/dhcpd`: rol para instalar y configurar DHCP.
- `.github/workflows/ci.yml`: checks básicos (syntax y lint).

### Requisitos

- Rocky Linux 9 en las VMs.
- Ansible instalado en la máquina `ansible`.
- Vagrant + VirtualBox (si usas el laboratorio con el `Vagrantfile`).

### Uso rápido

1. Levantar las VMs (si usas Vagrant):

   ```bash
   vagrant up
   ```

2. Conectarte al controlador:

   ```bash
   vagrant ssh ansible
   cd /vagrant
   ```

3. Probar conexión Ansible:

   ```bash
   ansible -i inventory/hosts.ini dns_dhcp_servers -m ping
   ```

4. Ejecutar el playbook:

   ```bash
   ansible-playbook -i inventory/hosts.ini site.yml
   ```

5. (Opcional) Modo check:

   ```bash
   ansible-playbook -i inventory/hosts.ini site.yml --check --diff
   ```

### Personalizar configuración

Edita `group_vars/all.yml` para ajustar:

- Dominio interno (`dns_zone_name`).
- Subred y rango DHCP (`dhcp_subnets`).
- Servidores DNS, gateway, lease times, reservas por MAC (`dhcp_reservations`).
- Interfaz donde escucha DHCP (`dhcp_listen_interface`).


### Pruebas básicas

- En el cliente, pedir IP por DHCP en la interfaz del laboratorio.
- Probar una resolución DNS contra la IP del servidor DNS.
