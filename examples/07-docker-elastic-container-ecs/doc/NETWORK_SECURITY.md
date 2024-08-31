# Network Security

Precisamos definir de onde podem vir as requisições e conexões para as máquinas quando criamos os grupos de segurança. Em muitos casos, como nas redes privadas, não queremos receber as requisições e conexões diretamente da internet, por questões de segurança. Então, o grupo de segurança deve fazer o papel de um firewall, filtrando o que pode e o que não pode passar.

Temos dois jeitos de especificar quais as fontes essas requisições podem alcançar nas nossas máquinas: pelo CIDR, para endereços de IPs, ou vindo de outros grupos de segurança.

Sempre que queremos receber as requisições diretamente da internet, usamos o CIDR, ele representa uma lista de endereços de IP, podendo ter um único item até $255^{4}$ membros (pouco mais de 4.2 bilhões de membros). Diante disso, imagine escrever uma lista com 4.2 bilhões de endereços?! Ao invés de escrevermos essa lista, usamos uma notação feita para o CIDR, em que representamos um bloco através do IP de início, seguido de uma barra e quantos bits podem ser substituídos.

Ao escrevermos 10.0.0.0/24, temos uma lista na qual os últimos 8 bits podem ser trocados, indo de 10.0.0.0 até 10.0.0.255. Se escrevermos 192.168.0.0/23, temos uma lista na qual os últimos 10 bits podem ser trocados, indo de 192.168.0.0 até 192.168.0.255 e de 192.168.1.0 até 192.168.1.255. Os conjuntos mais comuns são 0.0.0.0/0 que servem para todos os endereços existentes, 10.0.0.0/16 e mais alguns; você pode encontar uma lista completa para os endereços IPv4 e IPv6 aqui.

A outra opção é definir um grupo de segurança como a entrada, assim as máquinas só podem receber requisições de outros recursos criados por você, como um load balancer, o que oferece uma segurança maior.

Outro exemplo é caso tenhamos instâncias que realizam cálculos ou que contenham um banco de dados e que não são instâncias de uma API ou um servidor web. Por essas instâncias terem informações sensíveis, não podemos deixá-las abertas para a internet. Entretanto, caso queiramos acessar via ssh, podemos usar uma máquina na rede pública, e aumentar assim a segurança; e mesmo que a máquina seja comprometida, o banco de dados está protegido, pois não podemos fazer requisições diretas para ele.