import {htmlReport} from "https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js";
import {textSummary} from "https://jslib.k6.io/k6-summary/0.0.1/index.js";
import http from 'k6/http';
import {check} from 'k6';

const {SCENARIO} = __ENV || 'baseline_http';

const scenarios = {
    baseline_http: {
        executor: 'ramping-vus',
        startVUs: 0,
        stages: [
            { duration: '5s', target: 10 },
            { duration: '5s', target: 20  },
            { duration: '15s', target: 50 },
        ],
        exec: 'baselineHttp',
    },
    baseline_messaging: {
        executor: 'ramping-vus',
        startVUs: 0,
        stages: [
            { duration: '5s', target: 10 },
            { duration: '5s', target: 20 },
            { duration: '15s', target: 50 },
        ],
        exec: 'baselineMessaging',
    },
    highload_http: {
        executor: 'ramping-vus',
        startVUs: 0,
        stages: [
            {duration: '5s', target: 50},
            {duration: '5s', target: 100},
            {duration: '10s', target: 200},
            {duration: '10s', target: 200}, // hold
        ],
        exec: 'highLoadHttp',
    },
    highload_messaging: {
        executor: 'ramping-vus',
        startVUs: 0,
        stages: [
            {duration: '5s', target: 50},
            {duration: '5s', target: 100},
            {duration: '10s', target: 200},
            {duration: '10s', target: 200}, // hold
        ],
        exec: 'highLoadMessaging',
    },
    largepayload_http: {
        executor: 'ramping-vus',
        startVUs: 0,
        stages: [
            {duration: '5s', target: 10},
            {duration: '10s', target: 25},
            {duration: '15s', target: 25}, // hold
        ],
        exec: 'largePayloadHttp',
    },
    largepayload_messaging: {
        executor: 'ramping-vus',
        startVUs: 0,
        stages: [
            {duration: '5s', target: 10},
            {duration: '10s', target: 25},
            {duration: '15s', target: 25}, // hold
        ],
        exec: 'largePayloadMessaging',
    }
};


export const options = {
    scenarios: {
        [SCENARIO]: scenarios[SCENARIO],
    },
    thresholds: {
        http_req_duration: ['p(95)<500'],
    },
};

const directHttpUrl = 'http://localhost:5179';
const messagingUrl = 'http://localhost:5026';

function resolveUrl(execName) {
    if (execName === 'largepayload_http') return `${directHttpUrl}/orders/100`;
    if (execName === 'largepayload_messaging') return `${messagingUrl}/orders/100`;
    if (execName.includes('http')) return `${directHttpUrl}/orders/5`;
    if (execName.includes('messaging')) return `${messagingUrl}/orders/5`;
    throw new Error(`Unknown exec name: ${execName}`);
}

function run(execName) {
    const url = resolveUrl(execName);
    const res = http.get(url);
    check(res, {
        [`[${execName}] status 200`]: (r) => r.status === 200,
    });
}

export function baselineHttp() {
    run('baseline_http');
}

export function baselineMessaging() {
    run('baseline_messaging');
}

export function highLoadHttp() {
    run('highload_http');
}

export function highLoadMessaging() {
    run('highload_messaging');
}

export function largePayloadHttp() {
    run('largepayload_http');
}

export function largePayloadMessaging() {
    run('largepayload_messaging');
}
export function handleSummary(data) {
    const filename = `benchmarkResults/${SCENARIO}-report.html`;
    return {
        [filename]: htmlReport(data),
        stdout: textSummary(data, {indent: ' ', enableColors: true}),
    };
}
