<h1>Terraform en porxmox</h1>
<h2>Grupo elinas-Projecto Intermodular 1ºASIR</h2>
<h3>Descipcion</h3>
<p>
  Utilizando proxmox creamos una infresturcutra con la siguiente arquitectura
  <img width="2019" height="535" alt="IMG-20260518-WA0014" src="https://github.com/user-attachments/assets/67e4fe4e-23f6-455c-b022-8e181737ebee" />
  Consta de 2 maquinas con servidor web con una base de datos comun y luego un balanceador de carga apuntando a las maquinas web todo esto creado con LXC en un srv proxmox.
</p>

<h3>Para ejecutar</h3>

```
git clone https://github.com/DevoutElk/Terraform-CT.git
terraform init
terraform apply
```
