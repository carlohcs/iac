# Load Balancer

Ref: [https://aws.amazon.com/pt/elasticloadbalancing/features/](https://aws.amazon.com/pt/elasticloadbalancing/features/)

Os Load Balancers permitem que as nossas aplicações sejam distribuídas entre várias máquinas, já que eles distribuem as requisições entre diferentes instâncias da aplicação com o intuito de aliviar a carga em cima de uma única máquina.

Porém, podemos fazer isso de várias maneiras:direcionar cada requisição, cada porta de rede ou endereço de IP; isso define 3 tipos diferentes de Load Balancers.

O Gateway Load Balancer é um Load Balancer de layer 3, ou da 3º camada; é como são chamados os Load Balancers que trabalham apenas com endereços de IP, então se enviarmos uma requisição para um load balancer desse tipo vamos ser direcionados para uma máquina, independente do que queremos fazer, podendo ser uma requisição HTTP, SSH, ou uma conexão em uma porta UDP.

Geralmente não usamos os Load Balancers de layer 3 pois oferecem poucos recursos se comparados aos próximos 2 tipos.

O Network Load Balancer é um Load Balancer de layer 4, ou da 4º camada, e esse tipo trabalha com as portas das máquinas, então podemos diferenciar as requisições por tipos e ter máquinas que respondem apenas requisições para a porta 80 (geralmente HTTP), outras máquinas que respondem requisições na porta 443 (geralmente HTTPS) e máquinas que respondem apenas requisições na porta 3000.

Os Load Balancer de layer 4 também conseguem diferenciar conexões TCP e UDP, e são muito empregados pois são os que têm a implementação mais simples e fazem as distribuições das requisições de forma mais rápida e sem modificar o conteúdo.

O Application Load Balancer que criamos para o projeto é considerado um Load Balancer de layer 7, em que é analisado o pacote de rede e seu conteúdo, então o Load Balancer sabe se o pacote é HTTP, HTTPS, SSH, ou outro protocolo. Além disso, ele pode fazer a desencriptação e encriptação do conteúdo do pacote, além de compressão dos dados caso necessário.

Isso faz com que o conteúdo dos pacotes seja modificado, e apesar de normalmente não termos problemas, pode causar incompatibilidades em casos muito específicos; além disso acaba consumindo um tempo maior de processamento e não consegue responder a tantas requisições quanto os tipos 3 e 4.

Existe também o Classic Load Balancer que é uma mistura entre o Application e o Network Load Balancers, desempenhando as 2 tarefas ao mesmo tempo, porém acabava sendo mais lento que os 2.

Se você está criando recursos agora na EC2 não é necessário se preocupar com a EC2-Classic ou o Classic Load Balancer, ambos já não são criados por padrão.

--

Ao criar um Load Balancer é necessário informar um grupo de destino, que pode ser visto como target-group. Com isso, você irá estabelecer o alvo utilizado pelo Load Balancer para se comunicar e verificar a integridade da sua aplicação.

Para isso, como pode ser visto na documentação, há alguns tipos que podemos utilizar:

instance: alvo dado por padrão e é registrado pelo ID da instância; esse ID é único e é gerado automaticamente.
ip: estabelece o alvo por endereço IP, podendo ser endereços das sub-redes da sua VPC (Virtual Private Cloud ou Nuvem Virtual Privada) no intervalo 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 e 100.64.0.0/10, lembrando que podemos usar todos os IPs dentro destes intervalos como 10.0.101.0/24.
lambda: registra uma função lambda como alvo, essas são chamadas de funções serverless, já que não temos que criar máquinas para a execução destas funções.
alb: estabelece um ALB (Application Load Balancer ou Balanceador de Cargas para aplicações) como alvo, e nesse caso temos que usar um Network Load Balancer, já que não faz sentido direcionar um ALB para outro ALB. Podemos colocar todas as instâncias diretamente no primeiro ALB.