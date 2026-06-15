const service = require('../../application/services/PersonService');

exports.getAll = async (req, res) => {
    try {
        const data = await service.getAll();

        res.json({
            success: true,
            data
        });

    } catch (error) {
        res.status(500).json({
            success: false,
            message: error.message
        });
    }
};

exports.create = async (req, res) => {
    try {
        const result = await service.create(req.body);

        res.status(201).json({
            success: true,
            data: result
        });

    } catch (error) {
        res.status(400).json({
            success: false,
            message: error.message
        });
    }
};