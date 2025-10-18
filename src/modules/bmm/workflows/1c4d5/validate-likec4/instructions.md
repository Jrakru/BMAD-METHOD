# Validate 1C4D5 LikeC4 Assets

<workflow>

<critical>Always execute validations from the project root so relative paths in the starter-pack scripts resolve correctly.</critical>
<critical>Capture the full command output (pass/fail) in the validation report.</critical>

<step n="1" goal="Establish validation scope">
  <action>Create the directory {{validation_output_dir}} if it does not exist.</action>
  <ask response="validation_target">Which diagrams, flows, or stories were recently changed (or should be revalidated)?</ask>
  <ask optional="true" response="skip_sections">Any sections to skip (provide justification)?</ask>
  <template-output>validation_scope</template-output>
</step>

<step n="2" goal="Run automated validation pipeline">
  <action>Execute {{validation_script}} to run starter-pack `validate.py`, `compute_hashes.py`, and the LikeC4 CLI in one pass.</action>
  <action>Review the generated logs under {project-root}/reports/likec4 (validate.log, compute_hashes.log, likec4_validate.log).</action>
  <action>Record any reported errors with codes (E100, E101, etc.) and affected files.</action>
  <template-output>local_checks</template-output>
</step>

<step n="3" goal="Capture additional LikeC4 CLI details" optional="true">
  <action>If further detail is required, rerun the LikeC4 CLI manually (e.g., <code>likec4 validate --model likec4/model --views likec4/views</code>) and capture the verbose output.</action>
  <action>Document any warnings or rendered artifacts created during the manual run.</action>
  <template-output>likec4_results</template-output>
</step>

<step n="4" goal="Plan remediation">
  <action>Summarize all issues grouped by severity (blocking vs advisory).</action>
  <action>Assign remediation steps (update diagrams, rerun workflow, open work items).</action>
  <action>Schedule a follow-up validation if needed.</action>
  <template-output>remediation_plan</template-output>
</step>

<step n="5" goal="Publish validation report">
  <action>Compile a report covering scope, commands executed, results, remediation plan, and next steps.</action>
  <action>If all checks passed, explicitly record the success and timestamp.</action>
  <template-output>validation_summary</template-output>
  <ask>Share validation summary with architect/product owner? (y/n)</ask>
</step>

</workflow>
