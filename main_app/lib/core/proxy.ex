defmodule Core.Proxy do
	@behaviour DistributedModule
	def init() do
		DebugLogger.print("[PROXY] iniciado")
		proxy(NodeRepository.get_module_pid("master"))
	end

	defp proxy(master_pid) do
		receive do
			{exchange, worker} -> DebugLogger.print("[PROXY] Master quiere que monitorice worker. Abro hilo para #{inspect(worker)}")
												spawn(fn -> Core.Proxy.start_monitor(worker, exchange, master_pid) end)
												proxy(master_pid)
		end
	end

	def start_monitor(worker, exchange, master_pid) do
		DebugLogger.print("[PROXY] Monitor for worker #{inspect(worker)} starts")
		Node.monitor(elem(worker, 1), true)
		send(worker, {:req, {self(), exchange}})
		monitor(worker, exchange, master_pid)
	end

	defp monitor(worker, exchange, master_pid) do
		receive do
			{:alive} -> DebugLogger.print("[PROXY] Worker is alive. Keep goin'")
						monitor(worker, exchange, master_pid)
			
			after 30_000 -> DebugLogger.print("[PROXY] Worker is down. Notify Master")
							send(master_pid, {:worker_down, exchange})
		end
	end
end
