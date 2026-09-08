targetScope = 'subscription'

@description('Deployment environment')
param environment string

@description('Azure region')
param location string

@description('Gateway Load Balancer configuration')
param gatewayLoadBalancerConfig object

module gatewayLoadBalancerModule './networking/gatewayLoadBalancer.bicep' = {
  name: 'gwlb-${gatewayLoadBalancerConfig.loadBalancerName}-${environment}'
  scope: resourceGroup(gatewayLoadBalancerConfig.resourceGroupName)

  params: {
    loadBalancerName: gatewayLoadBalancerConfig.loadBalancerName
    location: gatewayLoadBalancerConfig.location

    subnetId: gatewayLoadBalancerConfig.subnetId

    frontendName: gatewayLoadBalancerConfig.frontendName

    backendPoolName: gatewayLoadBalancerConfig.backendPoolName

    internalTunnelIdentifier: gatewayLoadBalancerConfig.internalTunnelIdentifier
    internalTunnelPort: gatewayLoadBalancerConfig.internalTunnelPort

    externalTunnelIdentifier: gatewayLoadBalancerConfig.externalTunnelIdentifier
    externalTunnelPort: gatewayLoadBalancerConfig.externalTunnelPort

    probeName: gatewayLoadBalancerConfig.probeName
    probePort: gatewayLoadBalancerConfig.probePort

    ruleName: gatewayLoadBalancerConfig.ruleName

    tags: gatewayLoadBalancerConfig.tags
  }
}
