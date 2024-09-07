Oi pessoal.

API Gateway = Recebe as chamadas via API (HTTPS);
Lambda = Verifica o valor X e determina se deve registrar um novo usuário ou entrar com um existente, ou ainda, dar um bypass em usuários que não desejam se identificar (anônimo), além de determinar se aquele acesso é de um cliente ou administrativo (autenticado);
Cognito = Diretório de usuários (User Pools);

Mas, nada impede de vocês excluírem o Cognito e tratar todo permissionamento através da lambda somente. Com o cognito o sistema de permissionamento e autenticação faz com que a lambda fique mais simples.


Estou desenhando uma aplicação dentro da AWS, usando EKS e Kubernetes. Para aplicar as configurações, estou usando o terraform.

Preciso que crie uma configuração onde:
- existam duas redes privadas;
- uma rede pública;
- configurações para que rode que o deployment do kubernetes rode a imagem "carlohcs/basic-app" na porta 3000;
- configurações para que o kubernetes tenha LoadBalancer;
- grupos de segurança que permitam a conexão de entrada e saída;
- garanta que os recursos possam ser destruídos e recriados sempre;

Variáveis a serem criadas com seus respectivos valores padrões:
-  aws_profile = "academy"
- aws_region  = "us-east-1"
-  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
-  cluster_name = "basic-app-cluster"
 - node_role_arn = "arn:aws:iam::520138362070:role/LabRole"
-  instance_type = "t3.medium"
 - ssh_key_name = "aws-ec2-access"
 - ssh_key = "~/.ssh/aws-ec2-access"
-  environment = "dev"

Ao final, me explique como um usuário conseguirá acessar esta aplicação pela URL do LoadBalancer e como se dá a relação dos serviços no sentido de:

- O usuário entra pela URL do LoadBalancer <x>;
- A plataforma então irá direcionar a uma VPC <x>;
- O grupo de acesso irá...
- O Kubernetes responderá...
- A aplicação por fim responderá.