import json
import time

import requests


def get_content(url):
    time.sleep(0.2)
    response = requests.get(url)
    if response.status_code == 404 or response.status_code == 403:
        print("Not found!")
        return None
    else:
        return response.text


def extract_comparison_results(system_name, job_nrs):
    with open("comparison_results.csv", "w") as results_file:
        results_file.write("system,instances,throughput,latency\n")
        for job_nr in job_nrs:
            print("Doing job %d" % job_nr)
            for instances in [50, 100, 150, 200, 250, 300, 350, 400, 450, 500]:
                if system_name == "xchange":
                    base_url = "https://jenkins-ci.tribler.org/job/AnyDex/job/anydex_scale_multi_comparison/%d/DAS5=DAS5_TUD,GUMBY_das4_instances_to_run=%d/artifact/output/" % \
                               (job_nr, instances)
                else:
                    base_url = "https://jenkins-ci.tribler.org/job/market_experiments/job/%s_scale_multi/%d/DAS5=DAS5_VU,GUMBY_das4_instances_to_run=%d/artifact/output/" % \
                               (system_name, job_nr, instances)
                print(base_url)

                if system_name == "xchange":
                    stats_content = get_content(base_url + "aggregated_market_stats.log")
                    latency = None
                    if stats_content:
                        json_content = json.loads(stats_content)
                        latency = json_content["avg_order_latency"]
                else:
                    latency_content = get_content(base_url + "latency.txt")
                    latency = None
                    if latency_content:
                        latency = float(latency_content)

                throughput_name = "blocks_throughput.txt" if system_name == "xchange" else "throughput.txt"
                throughput_content = get_content(base_url + throughput_name)
                throughput = None
                if throughput_content:
                    throughput = float(throughput_content)

                if latency != None and throughput != None:
                    # Write result away
                    results_file.write("%s,%d,%d,%f\n" % (system_name, instances, int(throughput), latency))

def extract_scalability_results(job_nrs):
    with open("scalability_results.csv", "w") as results_file:
        results_file.write("policy,instances,throughput,latency\n")
        for job_nr in job_nrs:
            print("Doing job %d" % job_nr)
            for instances in [100, 200, 300, 400, 500, 600, 700, 800, 900, 1000]:
                for concurrent_trades in [0, 1]:
                    for transfers_per_trade in [1, 2]:
                        base_url = "https://jenkins-ci.tribler.org/job/AnyDex/job/anydex_scale_multi/DAS5=DAS5_TUD,GUMBY_MAX_CONCURRENT_TRADES=%d,GUMBY_TRANSFERS_PER_TRADE=%d,GUMBY_das4_instances_to_run=%d/%d/artifact/output/" % \
                                   (concurrent_trades, transfers_per_trade, instances, job_nr)
                        print(base_url)

                        # Determine the policy
                        policy = ""
                        if concurrent_trades == 0 and transfers_per_trade == 1:
                            policy = "none"
                        elif concurrent_trades == 1 and transfers_per_trade == 1:
                            policy = "RESTRICT(1)"
                        elif concurrent_trades == 0 and transfers_per_trade == 2:
                            policy = "INCSET(2)"
                        elif concurrent_trades == 1 and transfers_per_trade == 2:
                            policy = "RESTRICT(1)+INCSET(2)"

                        stats_content = get_content(base_url + "aggregated_market_stats.log")
                        avg_latency = None
                        if stats_content:
                            json_content = json.loads(stats_content)
                            avg_latency = json_content["avg_order_latency"]

                        throughput_content = get_content(base_url + "throughput.txt")
                        throughput = None
                        if throughput_content:
                            throughput = int(throughput_content)

                        if avg_latency != None and throughput != None:
                            # Write result away
                            results_file.write("%s,%d,%d,%f\n" % (policy, instances, throughput, avg_latency))


#extract_scalability_results([25])
extract_comparison_results("waves", [5, 6, 7, 8, 9, 10])
