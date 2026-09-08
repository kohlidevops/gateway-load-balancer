@description('Gateway Load Balancer name')
param loadBalancerName string

@description('Azure region')
param location string

@description('Subnet resource ID for the Gateway Load Balancer frontend')
param subnetId string

@description('Frontend IP configuration name')
param frontendName string

@description('Backend pool name')
param backendPoolName string

@description('Internal tunnel interface identifier')
param internalTunnelIdentifier int

@description('Internal tunnel interface port')
param internalTunnelPort int

@description('External tunnel interface identifier')
param externalTunnelIdentifier int

@description('External tunnel interface port')
param externalTunnelPort int

@description('Health probe name')
param probeName string

@description('Health probe port')
param probePort int

@description('HA ports load balancing rule name')
param ruleName string

@description('Resource tags')
param tags object


var frontendIpConfigurationId = resourceId(
  'Microsoft.Network/loadBalancers/frontendIPConfigurations',
  loadBalancerName,
  frontendName
)

var backendPoolId = resourceId(
  'Microsoft.Network/loadBalancers/backendAddressPools',
  loadBalancerName,
  backendPoolName
)

var probeId = resourceId(
  'Microsoft.Network/loadBalancers/probes',
  loadBalancerName,
  probeName
)


resource gatewayLoadBalancer 'Microsoft.Network/loadBalancers@2025-05-01' = {
  name: loadBalancerName
  location: location
  tags: tags

  sku: {
    name: 'Gateway'
  }

  properties: {
    frontendIPConfigurations: [
      {
        name: frontendName

        properties: {
          subnet: {
            id: subnetId
          }

          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]

    backendAddressPools: [
      {
        name: backendPoolName

        properties: {
          tunnelInterfaces: [
            {
              identifier: internalTunnelIdentifier
              port: internalTunnelPort
              protocol: 'VXLAN'
              type: 'Internal'
            }
            {
              identifier: externalTunnelIdentifier
              port: externalTunnelPort
              protocol: 'VXLAN'
              type: 'External'
            }
          ]
        }
      }
    ]

    probes: [
      {
        name: probeName

        properties: {
          protocol: 'Tcp'
          port: probePort
          intervalInSeconds: 15
          numberOfProbes: 2
        }
      }
    ]

    loadBalancingRules: [
      {
        name: ruleName

        properties: {
          frontendIPConfiguration: {
            id: frontendIpConfigurationId
          }

          backendAddressPool: {
            id: backendPoolId
          }

          probe: {
            id: probeId
          }

          protocol: 'All'
          frontendPort: 0
          backendPort: 0

          enableFloatingIP: false

          idleTimeoutInMinutes: 4
        }
      }
    ]
  }
}


output gatewayLoadBalancerId string = gatewayLoadBalancer.id

output gatewayLoadBalancerName string = gatewayLoadBalancer.name

output frontendIpConfigurationId string = frontendIpConfigurationId

output backendPoolId string = backendPoolId
