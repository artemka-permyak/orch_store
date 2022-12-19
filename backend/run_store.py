import uvicorn
from services.orch_store.main import factory

app = factory()

if __name__ == '__main__':
    uvicorn.run(
        'run_store:app', host='0.0.0.0', port=8010, reload=True, debug=True, log_config='etc/logging.conf'
    )
