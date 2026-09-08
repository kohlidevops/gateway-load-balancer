using '../modules/main.bicep'

param environment = 'dev'

param location = 'centralus'

param gatewayLoadBalancerConfig = {
  resourceGroupName: 'rg-sql-ag-dev'

  loadBalancerName: 'dcv-apigw-lb-dev'

  location: location

  subnetId: '/subscriptions/a98c3501-7e50-4380-a713-b02e7444f4e5/resourceGroups/rg-sql-ag-dev/providers/Microsoft.Network/virtualNetworks/vnet-sql-ag-dev/subnets/application-subnet'

  frontendName: 'gwlb-frontend'

  backendPoolName: 'api-gateway-backend-pool'

  internalTunnelIdentifier: 900

  internalTunnelPort: 10800

  externalTunnelIdentifier: 901

  externalTunnelPort: 10801

  probeName: 'api-gateway-health-probe'

  probePort: 443

  ruleName: 'gwlb-ha-rule'

  tags: {
    Environment: environment
    Project: 'API-Gateway'
    ManagedBy: 'Bicep'
    Owner: 'Infrastructure'
  }
}
