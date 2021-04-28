for i in `kubectl get nodes --show-labels | awk '{print $1}' | sed '1d'`; do kubectl label nodes $i app=getground-techtest; done
