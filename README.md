# IAC

A infraestrutura como código, também chamada de IaC, é uma forma que nós temos de escrever e executar código para definir, implantar, atualizar e gerenciar a infraestrutura de sistemas.

Este projeto tem então por finalidade, prover um exemplo utilizando ferramentas apropriadas que vão possibilitar criarmos uma infraestrutura.

## Tools and Setup

<details>
  <summary>Terraform</summary>

  O Terraform é uma ferramenta de infraestrutura como código (IaC) que permite definir, provisionar e gerenciar recursos de infraestrutura em uma variedade de provedores de nuvem e serviços locais. Desenvolvido pela HashiCorp, o Terraform se destaca pela sua capacidade de orquestrar a infraestrutura de maneira declarativa.

  [https://www.terraform.io/](https://www.terraform.io/)

**Install**

<details>
  <summary>Ubuntu</summary>

Para instalar o Terraform no Ubuntu, utilize o comando abaixo:

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt install terraform
```

</details>

<details>
  <summary>MacOS</summary>

No caso do MacOS, instale através do brew com o comando abaixo:

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

</details>

<details>
  <summary>Windows</summary>

Para instalar no Windows existem 2 possibilidades:

Chocolatey

```bash
choco install terraform
```

</details>

</details>

<details>
  <summary>Ansible</summary>

  O Ansible é uma ferramenta de automação de TI que é utilizada para a gestão de configurações, implantação de aplicações e automação de tarefas de TI. Desenvolvido pela Red Hat, ele é popular por sua simplicidade, poder e facilidade de uso.

**Install**

```bash
python -m pip install ansible
```

</details>

<details>
  <summary>Paramiko</summary>

  O Paramiko é uma biblioteca Python que permite a interação com dispositivos remotos através do protocolo SSH (Secure Shell). Ele é amplamente utilizado para automatizar tarefas de administração de sistemas e para criar scripts que precisam interagir de forma segura com servidores remotos.

**Install**

```bash
python -m pip install paramiko
```

</details>

<details>
  <summary>AWS and AWS CLI</summary>

  O projeto será configurado para rodar com AWS. Por isso, certifique-se de ter o arquivo de `credentials` da AWS (geralmente em `~/.aws/credentials`)

  Certifique-se de ao configurar o `credentials`, de expor o perfil utilizado com a variável `AWS_PROFILE`.

  O AWS CLI (Command Line Interface) é uma ferramenta que permite interagir com os serviços da Amazon Web Services (AWS) diretamente do terminal, utilizando comandos de texto. Ela oferece uma interface unificada para gerenciar e automatizar a infraestrutura na nuvem da AWS.

  **Install**

Caso você ainda não tenha instalado a [AWS CLI](https://docs.aws.amazon.com/pt_br/cli/latest/userguide/install-cliv2.html), vá a página da AWS CLI e siga os procedimentos para o seu sistema operacional.

Depois de instalado você pode configurar a AWS usando o comando `aws configure`. Em seguida, será requisitada a chave secreta (_secret key_), que pode ser criada [nesta pagina](https://console.aws.amazon.com/iam/home?#/security_credentials), clicando em "Criar chave de acesso" na aba "Credenciais do AWS IAM".

</details>
</details>

## Getting Started

```bash
terraform init
```

> Terraform will download the necessary provider plugins and set up the backend configuration. This step is typically performed before running any other Terraform commands in a project.

```bash
terraform plan
```

> Terraform analyzes your configuration files and the current state of your infrastructure to determine what changes need to be made. It then generates a detailed report that outlines the actions it will take to achieve the desired state defined in your configuration files. This includes creating new resources, modifying existing resources, or destroying resources that are no longer needed.

```bash
terraform apply
```

> Terraform will apply the changes defined in the Terraform configuration files to the target infrastructure. This command is typically used after making changes to the Terraform configuration files to deploy or update the infrastructure resources.

```bash
terraform destroy
```

> Terraform reads the configuration files in your project and identifies the resources that were created. It then proceeds to destroy those resources, removing them from your infrastructure. This can include terminating virtual machines, deleting storage accounts, removing network configurations, and so on, depending on what resources were defined in your Terraform configuration.

## Examples

- [Example 01 - Running EC2 instance with a Hello World page](./examples/01-ec2-hello-world/README.md)
- [Example 02 - Running Python, virtualenv and Django web page](./examples/02-terraform-ansible-python/README.md)
- [Example 03 - Running Python, virtualenv, Django web API and AWS - with everything in place](./examples/03-terraform-ansible-django-api/README.md)
- [# Example 04 - Running Python, virtualenv, Django web API and AWS and Load Balancer and Stress Test](./examples/04-load-balancer/README.md)
- [# Example 05 - Docker and Elastic Beanstalk at AWS](./examples/05-docker-elastic-beanstalk/README.md)
