import sys
import os
import re

# Simple script to strip answers from questions with this format:
#
# 7. Which United Nations organ is primarily responsible for maintaining international peace and security?
# a. Economic and Social Council
# b. International Court of Justice
# c. Security Council
# d. General Assembly
# Answer: c
#
# And then put them in different files

def qm(file):
    answers = []
    questions = []
    
    print(f"Processing file: '{file}'")

    try:
        with open(file, 'r', encoding='utf-8') as f:
            text_content = f.read()
        
        sections = re.split(r'(Answer:.*?)(?:\n|$)', text_content, flags=re.IGNORECASE | re.DOTALL)
        sections = [s.strip() for s in sections if s.strip()]

        if not sections:
            print("Warning: No content or 'Answer:' tags found.")
            return

        q_num_seq = 0
        i = 0
        while i < len(sections):
            current_sec = sections[i]
            
            if current_sec.lower().startswith("answer:"):
                print(f"Warning: Unexpected answer line without preceding question: '{current_sec}'")
                i += 1
                continue

            q_text_raw = current_sec
            ans_line = ""

            if i + 1 < len(sections) and sections[i+1].lower().startswith("answer:"):
                ans_line = sections[i+1]
                i += 2
            else:
                print(f"Warning: Question block without clear 'Answer:' line: '{q_text_raw[:100]}...'")
                i += 1

            if ans_line:
                explicit_num_match = re.match(r'^\s*(\d+)\.\s*', q_text_raw)
                
                if explicit_num_match:
                    q_num = explicit_num_match.group(1)
                else:
                    q_num_seq += 1
                    q_num = q_num_seq
                
                try:
                    ans_text = ans_line.split("Answer:")[-1].strip().replace('\t', ' ')
                    answers.append(f"{q_num}. {ans_text}")
                    
                    questions.append(q_text_raw.strip().replace('\t', ' '))

                    print(f"Extracted -> Q: {q_num}, A: {ans_text}")

                except Exception as err:
                    print(f"Error parsing answer for Q {q_num} (Answer line: '{ans_line}'): {err}")
                    print(f"Problematic Q content:\n{q_text_raw[:200]}...")
            else:
                explicit_num_match = re.match(r'^\s*(\d+)\.\s*', q_text_raw)
                if explicit_num_match:
                    q_num = explicit_num_match.group(1)
                else:
                    q_num_seq += 1
                    q_num = q_num_seq
                
                questions.append(q_text_raw.strip().replace('\t', ' '))
                print(f"Note: Q {q_num} processed without explicit 'Answer:' line.")


        ans_fn = "answers.txt"
        q_fn = "questions.txt"

        with open(ans_fn, 'w', encoding='utf-8') as ans_f:
            for ans in answers:
                ans_f.write(ans + '\n')
        print(f"\nGenerated '{ans_fn}' with {len(answers)} answers.")

        with open(q_fn, 'w', encoding='utf-8') as q_f:
            for q in questions:
                q_f.write(q + '\n\n')
        print(f"Generated '{q_fn}' with {len(questions)} questions.")

    except FileNotFoundError:
        print(f"Error: File '{file}' not found. Check path. CWD: {os.getcwd()}")
    except Exception as err:
        print(f"Unexpected error: {err}")

if __name__ == "__main__":
    args = sys.argv
    if len(args) > 1:
        file = args[1]
        qm(file)
    else:
        print("Usage: python quizmake.py <input_text_file>")
        print("Example: python quizmake.py my_quiz_data.txt")
        print("\nNo input file. Provide path.")
