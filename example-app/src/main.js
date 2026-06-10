import './style.css';
import { PersistentUuid } from '@capgo/capacitor-persistent-uuid';

const output = document.getElementById('plugin-output');
const scopeInput = document.getElementById('uuid-scope');
const getIdButton = document.getElementById('get-id');
const resetIdButton = document.getElementById('reset-id');
const versionButton = document.getElementById('get-version');

const setOutput = (value) => {
  output.textContent = typeof value === 'string' ? value : JSON.stringify(value, null, 2);
};

const getOptions = () => {
  const scope = scopeInput.value.trim();
  return scope ? { scope } : undefined;
};

getIdButton.addEventListener('click', async () => {
  try {
    const result = await PersistentUuid.getId(getOptions());
    setOutput(result);
  } catch (error) {
    setOutput('Error: ' + (error?.message ?? error));
  }
});

resetIdButton.addEventListener('click', async () => {
  try {
    const result = await PersistentUuid.resetId(getOptions());
    setOutput(result);
  } catch (error) {
    setOutput('Error: ' + (error?.message ?? error));
  }
});

versionButton.addEventListener('click', async () => {
  try {
    const result = await PersistentUuid.getPluginVersion();
    setOutput(result);
  } catch (error) {
    setOutput('Error: ' + (error?.message ?? error));
  }
});
