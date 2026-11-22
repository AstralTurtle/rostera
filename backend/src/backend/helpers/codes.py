### Helper functions related to attendence codes
import secrets
from collections import defaultdict, deque

CHAR_LIST = "0123456789ABCDEFGHJKMNPQRSTVWXYZ"
KEEP = 2

session_codes: defaultdict[str, deque[str]] = defaultdict(lambda: deque(maxlen=KEEP))


def _gen_code() -> str:
    return "".join([secrets.choice(CHAR_LIST) for _ in range(6)])

def add_code_to_session(session_id: str) -> str:
    code = _gen_code()
    session_codes[session_id].appendleft(code)
    return code
    
def check_code(session_id: str, u_code: str) -> bool:
    codes = session_codes.get(session_id)
    if not codes:
        return False

    u_code = u_code.strip().upper()
    return u_code in codes


if __name__ == "__main__":
    print(_gen_code())