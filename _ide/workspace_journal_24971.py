# 2026-10-22T17:02:54.755427972
import vitis

client = vitis.create_client()
client.set_workspace(path="serious-aie-fft")

comp = client.get_component(name="central-controller-element")
comp.run(operation="PACKAGE")

comp.run(operation="IMPLEMENTATION")

comp.run(operation="C_SIMULATION")

vitis.dispose()

vitis.dispose()

vitis.dispose()

