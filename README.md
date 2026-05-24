<h1>Terraform en porxmox</h1>
<h2>Grupo elinas-Projecto Intermodular 1ºASIR</h2>
<h3>Descipcion</h3>
<p>
  Utilizando proxmox creamos una infresturcutra con la siguiente arquitectura
 <img width="1917" height="904" alt="image" src="https://github.com/user-attachments/assets/7ded7aee-e784-4ba4-a5a8-6e295421a22e" />
  Consta de 2 maquinas con servidor web con una base de datos comun y luego un balanceador de carga apuntando a las maquinas web todo esto creado con LXC en un srv proxmox.
</p>

<h3>Para ejecutar</h3>

```
git clone https://github.com/DevoutElk/Terraform-CT.git
terraform init
terraform apply
```
