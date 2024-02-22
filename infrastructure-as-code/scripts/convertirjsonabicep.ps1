param(
    [string] $ResourceGroupName
)

$ErrorActionPreference = "Stop"

az --version
az bicep install
az bicep upgrade
$json = @'
[
    {
        "cluster_name": "cluster_Produccion",
        "autoscale": {
            "min_workers": 1,
            "max_workers": 2
        },
        "spark_version": "10.3.x-scala2.12",
        "spark_conf": {
            "spark.sql.extensions": "org.apache.sedona.viz.sql.SedonaVizExtensions,org.apache.sedona.sql.SedonaSqlExtensions",
            "spark.serializer": "org.apache.spark.serializer.KryoSerializer",
            "spark.kryo.registrator": "org.apache.sedona.core.serde.SedonaKryoRegistrator",
            "spark.databricks.delta.preview.enabled": "true"
        },
        "azure_attributes": {
            "first_on_demand": 1,
            "availability": "ON_DEMAND_AZURE",
            "spot_bid_max_price": -1
        },
        "node_type_id": "Standard_DS4_v2",
        "driver_node_type_id": "Standard_DS12_v2",
        "ssh_public_keys": [],
        "custom_tags": {},
        "spark_env_vars": {},
        "autotermination_minutes": 10,
        "enable_elastic_disk": true,
        "cluster_source": "UI",
        "init_scripts": [
            {
                "dbfs": {
                    "destination": "dbfs:/FileStore/sedona/sedona-init.sh"
                }
            }
        ]
    }
]
'@
Convert-JsonToBicep -String $json