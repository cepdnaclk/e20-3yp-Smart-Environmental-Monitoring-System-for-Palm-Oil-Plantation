import ruleset from "../shared/ruleset.json";

export interface Rule {
  id: string;
  priority: number;
  severity: "info" | "warn" | "critical";
  message: string;
  recommendation: string;
  parameters: string[];
  conditions: string[];
}

export interface RuleResult {
  id: string;
  severity: "info" | "warn" | "critical";
  message: string;
  recommendation: string;
  parameters: string[];
}

type Vars = Record<string, any>;

/**
 * Safely evaluate a condition string with provided variables
 */
function evalCondition(condStr: string, vars: Vars): boolean {
  const names = Object.keys(vars);
  const vals = Object.values(vars);

  try {
    const fn = new Function(...names, `return (${condStr});`);
    return fn(...vals);
  } catch (e) {
    console.error("Condition eval error:", condStr, e);
    return false;
  }
}

/**
 * Run rules against the given variable set
 */
export function runRules(vars: Vars): RuleResult[] {
  const results: RuleResult[] = [];
  const rules: Rule[] = [...(ruleset as any).rules].sort(
    (a, b) => b.priority - a.priority
  );

  for (const r of rules) {
    let passed = true;
    for (const cond of r.conditions) {
      if (cond.trim() === "true") continue;
      if (!evalCondition(cond, vars)) {
        passed = false;
        break;
      }
    }
    if (passed) {
      results.push({
        id: r.id,
        severity: r.severity,
        message: r.message,
        recommendation: r.recommendation,
        parameters: r.parameters,
      });

      if (results.length > 1) {
        results.pop();
      }
    }
  }

  return results;
}
