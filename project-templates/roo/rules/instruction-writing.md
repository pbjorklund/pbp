# Instruction Writing Rules for LLM System Messages

MANDATORY requirements for writing effective system prompts and instructions for LLMs.

## Core Principles

- **MUST** eliminate ambiguity through precise, imperative language
- **MUST** define exact requirements rather than subjective guidelines
- **MUST** specify measurable validation criteria for all rules
- **MUST** include concrete consequences for violations
- **MUST** treat instructions as behavioral contracts, not suggestions

## Language Requirements

- **MUST** use imperative mood: "MUST do X" not "should consider doing X"
- **MUST** use modal verbs for enforcement levels:
  - `MUST` / `SHALL` - mandatory requirements (no exceptions)
  - `SHOULD` - recommended but not enforced
  - `MAY` / `CAN` - optional or permitted actions
  - `SHALL NOT` / `MUST NOT` - prohibited actions
- **MUST** avoid subjective terms: "appropriate", "reasonable", "good", "useful"
- **MUST** replace vague phrases with specific criteria

## Structure Requirements

- **MUST** start with clear scope and applicability statement
- **MUST** organize requirements into logical, focused sections
- **MUST** use consistent section naming with "Requirements" suffix
- **MUST** include "Violation Consequences" section with specific penalties
- **MUST** end with "Applies To" section defining scope

## Specificity Requirements

- **MUST** provide exact syntax examples for all format requirements
- **MUST** specify tools, commands, and validation methods explicitly
- **MUST** include concrete examples of correct and incorrect implementations
- **MUST** define numerical limits where applicable (character counts, nesting levels)
- **MUST** enumerate all permitted values for categorical requirements

## Validation Requirements

- **MUST** specify exact validation tools and commands for each requirement
- **MUST** define success criteria in measurable terms
- **MUST** include automated validation steps where possible
- **MUST** specify manual verification procedures when automation unavailable
- **MUST** require zero-tolerance for linting violations where applicable

## Enforcement Requirements

- **MUST** specify immediate failure actions for violations
- **MUST** require specific error message formats with rule citations
- **MUST** prohibit workarounds or alternative interpretations
- **MUST** define escalation procedures for rule conflicts
- **MUST** mandate behavior updates when rules change

## Behavioral Specification Requirements

- **MUST** define pre-operation validation steps
- **MUST** specify required response formats for success and failure
- **MUST** mandate documentation of decisions and assumptions
- **MUST** require explicit confirmation of rule application
- **MUST** prohibit proceeding without validation completion

## Anti-Patterns to Avoid

- **SHALL NOT** use wishy-washy language: "try to", "consider", "when possible"
- **SHALL NOT** provide multiple options without clear selection criteria
- **SHALL NOT** use passive voice: "mistakes should be avoided" → "MUST avoid mistakes"
- **SHALL NOT** rely on implicit understanding: "use best practices" → specify exact practices
- **SHALL NOT** include contradictory requirements without resolution hierarchy

## Example Transformations

### Bad (Vague and Ambiguous)
```
- Use appropriate indentation
- Write good comments
- Handle errors properly
- Consider security implications
```

### Good (Precise and Measurable)
```
- MUST use exactly 2 spaces for indentation (no tabs)
- MUST include comment header explaining file purpose
- MUST use `set -euo pipefail` for shell script error handling
- SHALL NOT include passwords, tokens, or API keys in any file
```

## Testing Requirements

- **MUST** validate instructions produce consistent LLM behavior
- **MUST** test edge cases and boundary conditions
- **MUST** verify error handling produces expected responses
- **MUST** confirm rule violations are properly detected and rejected
- **MUST** validate that successful operations meet all requirements

## Maintenance Requirements

- **MUST** review instructions when underlying tools or standards change
- **MUST** update examples to reflect current best practices
- **MUST** remove deprecated requirements rather than leaving conflicting rules
- **MUST** version control instruction changes with clear change logs
- **MUST** test instruction updates before deployment

## Meta-Requirements

- **MUST** apply these instruction-writing rules to themselves recursively
- **MUST** treat instruction quality as critical system reliability factor
- **MUST** prioritize precision over brevity when conflicts arise
- **MUST** assume LLMs will interpret instructions literally and pedantically
- **MUST** design instructions for worst-case scenario LLM behavior

## Violation Consequences

- Instructions with ambiguous language **WILL BE REJECTED**
- Instructions without validation criteria **WILL BE REJECTED**
- Instructions using subjective terms **WILL BE REJECTED**
- Instructions without consequence specifications **WILL BE REJECTED**

## Applies To

- All system prompts and behavioral instructions for LLMs
- Rule files, behavioral guidelines, and operational procedures
- Any documentation intended to control LLM behavior
- Quality standards and validation frameworks for AI systems
