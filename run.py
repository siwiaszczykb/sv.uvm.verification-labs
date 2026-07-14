import json
import os
import sys
import argparse

def main():
    parser = argparse.ArgumentParser(description="UVM Test Runner")
    parser.add_argument("config", help="Plik konfiguracyjny JSON")
    parser.add_argument("--cov", type=int, help="Generuj coverage (0 lub 1)")
    args = parser.parse_args()
    with open(args.config, 'r') as f:
        cfg = json.load(f)

    cov = args.cov if args.cov is not None else cfg.get("coverage_default", 0)
    print(f"\n=== START: {args.config} (COV={cov}) ===")

    print("\nkompilacja i elaboracja srodowiska...")
    if os.system(f"make clean init comp_rtl comp_tb elab COV={cov} > /dev/null 2>&1") != 0:
        print("kompilacja lub elaboracja zakonczona niepowodzeniem!")
        sys.exit(1)

    print("\nuruchamianie symulacji...")
    results = []
    
    for test in cfg["tests"]:
        test_name = test["name"]
        expect_error = test["expect_error"]
        print(f" -> {test_name}... ", end="", flush=True)
        os.system(f"make run TEST={test_name} COV={cov} WAVE=0 > /dev/null 2>&1")

        status = "FAIL"
        try:
            with open("log/sim.log", "r") as log_file:
                log_data = log_file.read()
                err_lines = [line for line in log_data.split('\n') if "UVM_ERROR :" in line]
                fatal_lines = [line for line in log_data.split('\n') if "UVM_FATAL :" in line]
                errors = int(err_lines[-1].split(':')[-1].strip()) if err_lines else 0
                fatals = int(fatal_lines[-1].split(':')[-1].strip()) if fatal_lines else 0

                if fatals > 0:
                    status = "FAIL"
                elif expect_error and errors > 0:
                    status = "PASS (wylapany przewidywany blad)"
                elif not expect_error and errors == 0:
                    status = "PASS"
        except Exception as e:
            status = f"FAIL (Blad odczytu logu)"

        results.append((test_name, status))
        print(f"[{status}]")
        os.rename("log/sim.log", f"log/{test_name}_sim.log")

    if cov == 1:
        print("\ngenerowanie raportu coverage...")
        os.system("make report COV=1 > /dev/null 2>&1")

    print("\n" + "="*40)
    print("PODSUMOWANIE")
    print("="*40)
    for r in results:
        print(f"{r[0]:<25}: {r[1]}")
    print("="*40 + "\n")

if __name__ == "__main__":
    main()